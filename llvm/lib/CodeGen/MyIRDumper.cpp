//===- MyIRDumper.cpp - MyIRDumper -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/IR/CFG.h"
#include "protobuf/IRInfo.pb.h"
#include <string>
#include <fstream>
#include <ostream>

using namespace llvm;

namespace {
  class MyIRDumper : public FunctionPass {
  public:
    static char ID;
    MyIRDumper() : FunctionPass(ID) {
        initializeMyIRDumperPass(*PassRegistry::getPassRegistry());
        IR_func_book = new irpb::IRFunctionBook();
    }

    bool runOnFunction(Function &F) override;
    bool doFinalization(Module &M) override;
    bool doInitialization(Module &M) override;

    irpb::IRFunctionBook* IR_func_book;
  };
}

char MyIRDumper::ID = 0;

std::string getBBLabel(const llvm::BasicBlock *Node) {
    if (!Node) 
        return "NULL_BB";

    if (!Node->getName().empty()) {
        return Node->getName().str();
    }

    std::string Str;
    llvm::raw_string_ostream OS(Str);
    Node->printAsOperand(OS, false);
    return OS.str();
}

bool MyIRDumper::runOnFunction(Function &F) {
    const std::string &FName = F.getName().str();
    irpb::IRFunction *FMsg = IR_func_book->add_fs();
    FMsg->set_funcname(FName);

    // repeated MIRBasicBlock MBBs
    for (auto &BB : F) {
        irpb::IRBasicBlock *BBMsg = FMsg->add_bbs();
        const std::string &BBID = getBBLabel(&BB);
        BBMsg->set_bblabel(BBID);

        // repeated MIRInst MIs
        for (auto &I : BB) {
            irpb::IRInst *IMsg = BBMsg->add_is();

            std::string opcodeName = I.getOpcodeName();
            IMsg->set_opcode(opcodeName);

            DebugLoc DL = I.getDebugLoc();
            InstIndex *II = I.getInstIndex();
            InstIndexSet IIS = I.getInstIndexSet();

            if (II) {
                irpb::InstIndex *IIMsg = new irpb::InstIndex();
                std::string funcName = II->getFuncName();
                std::string bbLabel = II->getBBLabel();
                unsigned instNo = II->getInstNum();
                IIMsg->set_funcname(funcName);
                IIMsg->set_bblabel(bbLabel);
                IIMsg->set_instno(instNo);
                IMsg->set_allocated_idx(IIMsg);
            }
            

            irpb::InstIndexList *IISMsg = new irpb::InstIndexList();
            InstIndexSet::iterator it = IIS.begin();
            // repeated InstIndex
            for (; it != IIS.end(); ++it) {
                if (*it == nullptr) continue;
                irpb::InstIndex *tmpII = IISMsg->add_idxs();
                std::string tmpfuncName = (*it)->getFuncName();
                std::string tmpbbLabel = (*it)->getBBLabel();
                unsigned tmpinstNo = (*it)->getInstNum();
                tmpII->set_funcname(tmpfuncName);
                tmpII->set_bblabel(tmpbbLabel);
                tmpII->set_instno(tmpinstNo);
            }
            IMsg->set_allocated_idxs(IISMsg);


            DebuginfoList DIL;
            bool status = false;
            I.getDebugInfoTree(DIL, status);
            if (status) {
                for (auto &DebugInfo : DIL) {
                    irpb::InstLoc *LocMsg = IMsg->add_locs();
                    LocMsg->set_filename(std::get<0>(DebugInfo));
                    LocMsg->set_lineno(std::get<1>(DebugInfo));
                    LocMsg->set_colno(std::get<2>(DebugInfo));
                }
            }
        }

        // repeated string SuccMBBLabel
        for (BasicBlock *S : successors(&BB)) {
            const std::string &SuccBB = S->getName().str();
            BBMsg->add_succbblabel(SuccBB); 
        }

        // repeated string PredMBBLabel
        for (BasicBlock *P : predecessors(&BB)) {
            const std::string &PredBB = P->getName().str();
            BBMsg->add_predbblabel(PredBB); 
        }

    }

    return false;
}

bool MyIRDumper::doInitialization(Module &M) {
    // test protobuf
    GOOGLE_PROTOBUF_VERIFY_VERSION;

    // get arch from Targrt Triple
    std::string triple = M.getTargetTriple();
    char* triple_buffer = new char[triple.size() + 1];
    std::strcpy(triple_buffer, triple.c_str());
    std::string delim = "-";
    char *arch_p = strtok(triple_buffer, delim.c_str());
    std::string arch(arch_p);

    // set arch
    IR_func_book->set_arch(arch);
    return false;
}

bool MyIRDumper::doFinalization(Module &M) {
    outs() << "Starting output IR Info... \n";
    // log name diff from MIR log
    std::fstream output("./IRlog", std::ios::out | std::ios::trunc | std::ios::binary);
    if (!IR_func_book->SerializePartialToOstream(&output)) {
        outs() << "Failed to write IR msg. \n";
        output.close();
        return true;
    }
    output.close();
    outs() << "Finish of dumping IR Info. \n";
    return false;
}

INITIALIZE_PASS(MyIRDumper, "MyIRDumper",
                "Dump IR Info before CodeGen", false, false)

FunctionPass *llvm::createMyIRDumperPass() {
  return new MyIRDumper();
}