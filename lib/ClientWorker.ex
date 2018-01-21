defmodule ClientWorker do
    def start_link do
        GenServer.start(__MODULE__,[])

    end
    def gen_bitcoins(pid, k, client_pid) do
        GenServer.cast(client_pid, {pid, k})
    end

    def handle_cast({pid, k}, state) do
        hashCrypto(k, 0, pid)
        {:noreply, state}
    end
    #TODO remove pid in the module
    def hashCrypto(k, i, pid) do
        #input="riddhima15;"<>random_string(6)<>Integer.to_string(i)
        #input="riarora;kjsdfk"<>Integer.to_string(i)
        input = "riddhima15;"<>get_string(6)
        output =  Base.encode16(:crypto.hash(:sha256,input))
        zeros = String.duplicate("0",k)

        if String.slice(output, 0..k-1) == zeros do
        #IO.puts "insideeeeeee"
            #if String.equivalent?(String.slice(output, k..k),"0")==false do
            #GenServer.cast(:MySupervisor, {:callGen, input<>"\t"<>output})
            ServerModule.print_bitcoins(:ServerGen, input<>"\t"<>output, pid)
            #IO.puts input<>"\t"<>output
            #end
        end
        i=i+1
        hashCrypto(k, i, pid)
    end
    def random_string(length) do
        :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
    end
    ## newwww
    def seed_random do
        use_monotonic = :erlang.module_info
            |> Keyword.get( :exports )
            |> Keyword.get( :monotonic_time )
        time_bif = case use_monotonic do
          1   -> &:erlang.monotonic_time/0
          nil -> &:erlang.now/0
        end
        :random.seed( time_bif.() )
    end

    def string( length ) do
        get_string( length )
    end

    def string() do
        get_string( 8 )
    end

    def get_string( length ) do
        seed_random
        alphabet
            =  "abcdefghijklmnopqrstuvwxyz"
            <> "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            <> "0123456789"
        alphabet_length =

        alphabet |> String.length

        1..length
          |> Enum.map_join(
            fn(_) ->
              alphabet |> String.at( :random.uniform( alphabet_length ) - 1 )
            end
          )
    end

    def number() do
        get_number(8)
    end

    def number( length ) do
        get_number( length )
    end

    def get_number( length ) do
        seed_random

        { number, "" } =
          Integer.parse 1..length
          |> Enum.map_join( fn(_) ->  :random.uniform(10) - 1 end )

        number
    end

end
