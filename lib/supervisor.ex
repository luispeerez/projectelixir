defmodule KV.Supervisor do
	use Supervisor

	def start_link(opts) do
		Supervisor.start_link(__MODULE__, :ok, opts)
	end

	def init(:ok) do
		children = [
			{KV.Registry, name: KV.Registry},
			KV.BucketSupervisor
		]

		#:one_for_one means that if a child dies, it will be the only one restarted
		#will call: KV.Registry.start_link([name: KV.Registry])
		Supervisor.init(children, strategy: :one_for_one)

	end
end