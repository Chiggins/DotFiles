set disassembly-flavor intel

python
import gdb

class RunUntilCommand(gdb.Command):
    """Run until breakpoint and temporary disable other ones"""

    def __init__ (self):
        super(RunUntilCommand, self).__init__ ("run-until",
                                               gdb.COMMAND_BREAKPOINTS)

    def invoke(self, bp_num, from_tty):
        try:
            bp_num = int(bp_num)
        except (TypeError, ValueError):
            print "Enter breakpoint number as argument."
            return

        all_breakpoints = gdb.breakpoints() or []
        breakpoints = [b for b in all_breakpoints
                       if b.is_valid() and b.enabled and b.number != bp_num and
                       b.visible == gdb.BP_BREAKPOINT]

        for b in breakpoints:
            b.enabled = False

        gdb.execute("run")

        for b in breakpoints:
            b.enabled = True

RunUntilCommand()
end
