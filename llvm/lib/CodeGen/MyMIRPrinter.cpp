//===- MyMIRPrinter.cpp - MyMIRPrinter -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/IR/ModuleSlotTracker.h"
#include <llvm/IR/Module.h>
#include "llvm/Support/CommandLine.h"
#include <string>
#include <map>
#include <list>
#include <set>
#include <fstream>
#include <ostream>

using namespace llvm;

#define My_MIR_PRINTER_PASS_NAME "Dummy machineIR-Info printer pass"

struct MyMIRPrinter
    : MachineFunctionPass {
  static char ID;

  MyMIRPrinter() : MachineFunctionPass(ID) {}  

  bool runOnMachineFunction (MachineFunction &F) override;
};

bool MyMIRPrinter::runOnMachineFunction(MachineFunction &MF) {
    // if (EnableMyMIRPrinterPass) {

    MF.dump();
    //     std::string funcname = MF.getName();
    // dbgs() << "FuncName:" << funcname << '\n';
    // unsigned MFID = MF.getFunctionNumber();
    // for (auto &MBB : MF) {
    //     std::string MBBID = std::to_string(MFID) + "_" + std::to_string(MBB.getNumber());
    //     dbgs() << "FUNC ID and BB ID:" << MBBID << '\n';
    //     if (!MBB.getBasicBlock()) outs() << "no label" << '\n';
    //     for (MachineBasicBlock::instr_iterator
    //      I = MBB.instr_begin(), E = MBB.instr_end(); I != E; ++I) {
    //         I->dump();
    //     }
    // }
    // }



    return false;
}

char MyMIRPrinter::ID = 0;

INITIALIZE_PASS(MyMIRPrinter, "my-machineIR-printer",
    My_MIR_PRINTER_PASS_NAME,
    true, // is CFG only?
    false  // is analysis?
)

namespace llvm {
// Usage: llc f.bc -my-mir-printer
FunctionPass *createMyMIRPrinterPass() { return new MyMIRPrinter(); }

} 