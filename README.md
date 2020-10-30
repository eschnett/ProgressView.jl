# ProgressView

A Julia package for displaying categorical progress information

* [GitHub](https://github.com/eschnett/ProgressView.jl): Source code repository
* [![GitHub CI](https://github.com/eschnett/ProgressView.jl/workflows/CI/badge.svg)](https://github.com/eschnett/ProgressView.jl/actions)

`ProgressView` displays periodically which functions a program is
currently executing with a stack-like view. This similar to a
hierarchical version of
[`ProgressMeter`](https://github.com/timholy/ProgressMeter.jl).

## Example

```Julia
function inner()
    return 2
end

function fun()
    x = @monitor "inner" inner()
    return nothing
end

function main()
    @monitor "fun" fun()
end
```

Sample snapshot of output:
```
1. fun
  2. inner
```
