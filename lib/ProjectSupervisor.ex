defmodule ProjectSupervisor do
    use Supervisor
    def start_link(args) do
        Supervisor.start_link(__MODULE__,args)
        {:ok, args}
    end
    def init(state) do
        #IO.puts state
        cores = 8
        k = state
        params = [cores, k]
        children = [
            worker(ServerModule, params)
        ]
        supervise(children, strategy: :one_for_one)
    end
end
