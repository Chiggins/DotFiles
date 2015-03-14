set disassembly-flavor intel

source /usr/share/peda/peda.py

# Most from: mammon.github.io./gdb_init.txt
# ______________breakpoint aliases_____________
define bpl
 info breakpoints
end
document bpl
List breakpoints
end

define bp
 set $SHOW_CONTEXT = 1
 break * $arg0
end
document bp
Set a breakpoint on address
Usage: bp addr
end

define bpc 
 clear $arg0
end
document bpc
Clear breakpoint at 
function/address
Usage: bpc addr
end

define bpe
 enable $arg0
end
document bpe
Enable breakpoint #
Usage: bpe num
end

define bpd
 disable $arg0
end
document bpd
Disable breakpoint #
Usage: bpd num
end

define bpt
 set $SHOW_CONTEXT = 1
 tbreak $arg0
end
document bpt
Set a temporary breakpoint 
on address
Usage: bpt addr
end

define bpm
 set $SHOW_CONTEXT = 1
 awatch $arg0
end
document bpm
Set a read/write breakpoint 
on address
Usage: bpm addr
end

define argv
 show args
end
document argv
Print program arguments
end

define stack
 info stack
end
document stack
Print call stack
end

#define frame
# info frame
# info args
# info locals
#end
#document frame
#Print stack frame
#end

define flags
 if (($eflags >> 0xB) & 1 )
  printf "O "
 else
  printf "o "
 end
 if (($eflags >> 0xA) & 1 )
  printf "D "
 else
  printf "d "
 end
 if (($eflags >> 9) & 1 )
  printf "I "
 else
  printf "i "
 end
 if (($eflags >> 8) & 1 )
  printf "T "
 else
  printf "t "
 end
 if (($eflags >> 7) & 1 )
  printf "S "
 else
  printf "s "
 end
 if (($eflags >> 6) & 1 )
  printf "Z "
 else
  printf "z "
 end
 if (($eflags >> 4) & 1 )
  printf "A "
 else
  printf "a "
 end
 if (($eflags >> 2) & 1 )
  printf "P "
 else
  printf "p "
 end
 if ($eflags & 1)
  printf "C "
 else
  printf "c "
 end
 printf "\n"
end
document flags
Print flags register
end

define eflags
 printf "     OF <%d>  DF <%d>  IF <%d>  TF <%d>",\
        (($eflags >> 0xB) & 1 ), (($eflags >> 0xA) & 1 ), 
\
        (($eflags >> 9) & 1 ), (($eflags >> 8) & 1 )
 printf "  SF <%d>  ZF <%d>  AF <%d>  PF <%d>  CF 
<%d>\n",\
        (($eflags >> 7) & 1 ), (($eflags >> 6) & 1 ),\
        (($eflags >> 4) & 1 ), (($eflags >> 2) & 1 ), 
($eflags & 1)
 printf "     ID <%d>  VIP <%d> VIF <%d> AC <%d>",\
        (($eflags >> 0x15) & 1 ), (($eflags >> 0x14) & 1 
), \
        (($eflags >> 0x13) & 1 ), (($eflags >> 0x12) & 1 
)
 printf "  VM <%d>  RF <%d>  NT <%d>  IOPL <%d>\n",\
        (($eflags >> 0x11) & 1 ), (($eflags >> 0x10) & 1 
),\
        (($eflags >> 0xE) & 1 ), (($eflags >> 0xC) & 3 )
end
document eflags
Print entire eflags register
end

define func
 info functions
end
document func
Print functions in target
end

define var
 info variables
end
document var
Print variables (symbols) in target
end

define lib
 info sharedlibrary
end
document lib
Print shared libraries linked to target
end

define sig
 info signals
end
document sig
Print signal actions for target
end

#define thread
# info threads
#end
#document thread
#Print threads in target
#end

define u
 info udot
end
document u
Print kernel 'user' struct for target
end

define dis
 disassemble $arg0
end
document dis
Disassemble address
Usage: dis addr
end


define assemble
printf "Hit Ctrl-D to start, type code to assemble, hit 
Ctrl-D when done.\n"
printf "It is recommended to start with\n"
printf "\tBITS 32\n"
printf "Note that this command uses NASM (Intel syntax) 
to assemble.\n"
shell nasm -f bin -o /dev/stdout /dev/stdin | od -v -t x1 
-w16 -A n
end
document assemble
Assemble Intel x86 instructions to binary opcodes. Uses 
nasm.
Usage: assemble
end


set history save
set history filename ~/.gdb_history
set confirm off
set verbose off
#set prompt gdb>
set output-radix 0x10
set input-radix 0x10
set height 0
set width 0	


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
