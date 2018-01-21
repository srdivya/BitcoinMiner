defmodule PROJECT1 do
  def main(args) do
    {_, [str], _} = OptionParser.parse(args)
    k = elem(Integer.parse(str), 0)
    strval= "#{k}"
    #elem(Integer.parse(str), 0)

    #k_zero_string = get_k_zero_string(k, "")

    if (strval =~ ".") do
        ClientModule.start_link(str)
        #GenServer.call(:MySupervisor, String.to_atom(server_name), {:clientcall, client_name})
        #IO.puts "Connected"
        #PROJECT1.Supervisor.call(:MySupervisor, server_name, {:ok, client_name})
        #send :global.whereis_name(:server), {:ok, client_name}0
    else
        #start supervisor
        ProjectSupervisor.start_link(k)
    end
  end
end
