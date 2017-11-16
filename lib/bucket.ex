defmodule KV.Bucket do
	use Agent, restart: :temporary

	@doc """
	Starts a new bucket
	"""
	def start_link(_opts) do
		Agent.start_link(fn -> %{} end)
	end

	@doc """
	Gets a value from the 'bucket' by 'key'
	"""
	def get(bucket, key) do
		Agent.get(bucket, &Map.get(&1, key))
	end

	@doc """
	Puts the value for the given key in the bucket
	"""
	def put(bucket, key, value) do
		Agent.update(bucket, &Map.put(&1, key, value))
	end

	@doc """
	Deletes `key` from `bucket`.

	Returns the current value of `key`, if `key` exists.
	"""	

	def simpleDelete(bucket, key) do
		Agent.get_and_update(bucket, &Map.pop(&1, key))
	end


	#When a long action is performed on the server, 
	#all other requests to that particular server will wait until the action is done, 
	#which may cause some clients to timeout.

	def delete(bucket, key) do
		Process.sleep(1000) #puts client to sleep

		#The agent process is the server
		Agent.get_and_update(bucket, fn dict -> 
			Process.sleep(1000) #puts server to sleep
			Map.pop(dict, key)
		end)
	end

end