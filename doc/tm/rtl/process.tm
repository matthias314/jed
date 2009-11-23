\function{get_process_input}
\synopsis{Read all pending input by all subprocesses}
\usage{Void get_process_input (Int_Type tsecs)}
\description
  Read all pending input by all subprocesses.  If no input is
  available, this function will wait for input until \var{tsecs} tenth of
  seconds have expired.
\seealso{open_process, kill_process}
\done

\function{get_process_flags}
\synopsis{Get the flags associated with a process}
\usage{Int_Type get_process_flags (Int_Type id)}
\description
  This function returns the flags associated with the current process.
  The \ifun{set_process_flags} may be used to set the flags.
\seealso{open_process, set_process_flags}
\done

\function{kill_process}
\synopsis{Kill the subprocess specified by the process handle "id"}
\usage{Void kill_process (Int_Type id)}
\description
  Kill the subprocess specified by the process handle \var{id}	    
\seealso{open_process}
\done

\function{open_process}
\synopsis{Open a process and return a unique process id}
\usage{Int_Type open_process (name, argv1, argv2, ..., argvN, N)}
\description
  Open subprocess \var{name}. Returns id of process, -1 upon failure.
\seealso{kill_process, process_mark, process_query_at_exit}
\done

\function{process_mark}
\synopsis{Return user mark for the position of the last output by the process}
\usage{User_Mark process_mark (Int_Type id)}
\description
  This function returns the user mark that contains the position of the
  last output by the process.
\done

\function{process_query_at_exit}
\synopsis{Whether or not to silently kill a process at exit}
\usage{Void process_query_at_exit (Int_Type pid, Int_Type query)}
\description
  The \var{process_query_at_exit} may be used to specify whether or
  not the process specified by \var{pid} should be silently ignored
  when the editor exits.  If the parameter \var{query} is non-zero,
  the user will be reminded the process exists before exiting.
\seealso{open_process, kill_process, exit_jed}
\done

\function{run_program}
\synopsis{Run another program in a window}
\usage{Int_Type run_program (String_Type pgm)}
\description
  Like the \var{system} function, the \var{run_program} function may
  be used to execute another program.  However, this function is more
  useful for executing interactive programs that require some sort of display
  manipulation, e.g., \var{lynx}, the text-mode web browser.  When
  called from \var{xjed}, the other program is executed asynchronously
  in a separate xterm window.  If the editor is running in an ordinary
  terminal, \var{jed} will be suspended while the other program runs.
  The function returns the exit value of the invoked process.
\example
#v+
     if (0 != run_program ("lynx http://www.jedsoft.org"))
       error ("lynx failed to run");
#v-
\notes
  The \var{XTerm_Pgm} variable may be used to specify the terminal
  that \var{xjed} uses when calling \var{run_program}.  For example,
  to use \var{rxvt}, use:
#v+
     variable XTerm_Pgm = "rxvt";
#v-
\seealso{system, open_process}
\done

\function{run_shell_cmd}
\synopsis{Run "cmd" in a separate process}
\usage{Integer_Type run_shell_cmd (String cmd)}
\description
  The \var{run_shell_cmd} function may be used to run \var{cmd} in a separate
  process.  Any output generated by the process is inserted into the
  buffer at the current point.  It generates a S-Lang error if the
  process specified by \var{cmd} could not be opened.  Otherwise, it
  returns the exit status of the process.
\done

\function{send_process}
\synopsis{Send a string to the specified subprocess}
\usage{Void send_process (Int_Type id, String s)}
\description
 This function sends the string \exmp{s} to the standard input of the
 process with the ID \var{id}.  With this function and
 \ifun{set_process} with the argument `output'' you can establish a
 bi-directional communication with the process.
\seealso{open_process, set_process, send_process_eof}
\done

\function{send_process_eof}
\synopsis{Close the "stdin" of the process "id"}
\usage{send_process_eof (Int_Type id)}
\description
  This function closes the \var{stdin} of the process specified by the
  handle \var{id}.
\done

\function{set_process}
\synopsis{Set "what" for process "pid"}
\usage{Void set_process (pid, what, value)}
#v+
   Int_Type pid;
   String_Type what;
   String_Type or Ref_Type value;
#v-
\description
  \var{pid} is the process handle returned by \var{open_process}.  The second
  parameter, \var{what}, specifies what to set.  It must be one of the
  strings:
#v+
        "signal" :  indicates that 'value' is the name of a function to call
                    when the process status changed.  The function specified
                    by 'value' must be declared to accept an argument list:
                    (pid, flags, status) where 'pid' has the same
                    meaning as above and flags is an integer with the
                    meanings: 
                      1: Process Running
                      2: Process Stopped
                      4: Process Exited Normally
                      8: Process Exited via Signal
                    The meaning of the status parameter depends
                    upon the flags parameter.  If the process
                    exited normally, then status indicates its
                    return status.  Otherwise status represents
                    the signal that either stopped or killed the
                    process.
                    Note: when this function is called, the current buffer is
                    guaranteed to be the buffer associated with the process.
       
       "output" :   This parameter determines how output from the process is
                    is processed.  If the 'value' is the empty string "", output
                    will go to the end of the buffer associated with the process
                    and the point will be left there.
                    If value is ".", output will go at the current buffer position.
                    If value is "@", output will go to the end of the buffer but
                    the point will not move.  Otherwise, 'value' is
                    the name or a reference to a slang function that
                    takes arguments: (pid, data) where pid has
                    the above meaning and data is the output from the process.
#v-
  Normally \jed automatically switches to the buffer associated with
  the process prior to handling data from the process.  This behavior
  may be modified through the use of the \ifun{set_process_flags}
  function.
\seealso{set_process_flags, get_process_flags, open_process}
\done

\function{set_process_flags}
\synopsis{Set the flags associated with a process}
\usage{set_process_flags (Int_Type id, Int_Type flags)}
\description
  This function may be used to set the flags associated with the
  specified process.  The flags may be used to affect the behavior of
  the process.  Currently the following bits are defined:
#v+
     0x01     Do not switch to the process buffer prior to calling any
                hooks associated with the buffer including output from
                the process.
#v-
\seealso{open_process, get_process_flags, set_process}
\done

\function{signal_process}
\synopsis{Send a signal to the process "pid"}
\usage{Void signal_process (Int_Type pid, Int_Type signum)}
\description
  This function may be used to send a signal to the process whose
  process handle is given by \var{pid}.  The \var{pid} must be a valid handle
  that was returned by \var{open_process}.
\seealso{open_process, kill_process, send_process_eof}
\done

