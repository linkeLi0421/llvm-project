#include "IRDumper.h"

using namespace sys::fs;

void saveModule(Module &M, Twine filename)
{
	//int ll_fd;
	//sys::fs::openFileForWrite(filename + "_pt.ll", ll_fd, 
	//		sys::fs::F_RW | sys::fs::F_Text);
	//raw_fd_ostream ll_file(ll_fd, true, true);
	//M.print(ll_file, nullptr);

	int bc_fd;
	openFileForWrite(filename + "_pt.bc", bc_fd);
	raw_fd_ostream bc_file(bc_fd, true, true);
	WriteBitcodeToFile(M, bc_file);
}

bool IRDumper::runOnModule(Module &M) {

	saveModule(M, M.getName());

	return true;
}

char IRDumper::ID = 0;
static RegisterPass<IRDumper> X("IRDumper", "IRDumper pass", false, false);

static void register_pass(const PassManagerBuilder &PMB,
		legacy::PassManagerBase &PM) {
	PM.add(new IRDumper());
}

static RegisterStandardPasses RegisterPass(
		PassManagerBuilder::EP_OptimizerLast, register_pass);
static RegisterStandardPasses RegisterPass1(
		PassManagerBuilder::EP_EnabledOnOptLevel0, register_pass);
