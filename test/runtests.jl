using ProgressView
using Test

function inner()
    sleep(1.1)
    return 2
end

function fun()
    sleep(1.1)
    x = @monitor "inner" inner()
    @test x == 2
    sleep(1.1)
    return nothing
end

@testset "ProgressView" begin
    @monitor "testset" begin
        @monitor "fun" fun()
    end
    sleep(1.1)
    @monitor "fun" fun()
    monitor_flush()
end
