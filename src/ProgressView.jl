module ProgressView

export @monitor, monitor_flush, reset_tasks!, push_task!, pop_task!,
       maybe_display_tasks, display_tasks

const ESC = "\e"                # escape
const CR = "\r"                 # carriage return
const NL = "\n"                 # next line

const CSI = "$ESC["             # control sequence introducer
const CUU = "$(CSI)A"           # cursor up
const CUD = "$(CSI)B"           # cursor down
const ED = "$(CSI)J"            # erase in display
const EL = "$(CSI)K"            # erase in line

const update_every = 1.0       # update output every that many seconds

const stack = Vector{String}()  # current task stack

const lastoutput = Vector{String}() # currently displayed task stack
const lasttime = Ref(0.0)           # time at which stack was output

macro monitor(taskname::AbstractString, task)
    quote
        push_task!($taskname)
        local result = $(esc(task))
        pop_task!()
        result
    end
end

monitor_flush() = display_tasks()

function reset_tasks!()
    empty!(stack)
    display_tasks()
    return nothing
end

function push_task!(task::AbstractString)
    push!(stack, String(task))
    maybe_display_tasks()
    return nothing
end

function pop_task!()
    pop!(stack)
    maybe_display_tasks()
    return nothing
end

function maybe_display_tasks()
    currenttime = time_ns() / 1.0e+9
    if currenttime ≥ lasttime[] + update_every
        display_tasks()
        lasttime[] = currenttime
    end
    return nothing
end

function display_tasks()
    currentoutput = copy(stack)

    # Find first difference between current and last output
    tstart = 1
    while tstart ≤ length(lastoutput) &&
              tstart ≤ length(currentoutput) &&
              lastoutput[tstart] == currentoutput[tstart]
        tstart += 1
    end

    # Move cursor up to the first line that needs outputting
    tmove = length(tstart:length(lastoutput))
    print("$CUU"^tmove)
    # Output new lines
    for line in tstart:length(currentoutput)
        print("  "^(line - 1), "$line: ", currentoutput[line], "$EL$NL")
    end
    # Clear remaining lines
    print("$ED")

    # Save state
    copy!(lastoutput, currentoutput)

    return nothing
end

end
