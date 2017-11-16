defmodule KV.RegistryTest do
	use ExUnit.Case, async: true

	setup do
		{:ok, registry} = start_supervised KV.Registry
		%{registry: registry}
	end

	test "spawn buckets", %{registry: registry} do
		assert KV.Registry.lookup(registry, "shopping") == :error

		KV.Registry.create(registry, "shopping")
		assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

		KV.Bucket.put(bucket, "milk", 1)
		assert KV.Bucket.get(bucket, "milk") == 1
	end

	test "removes bucket on exit", %{registry: registry} do
		KV.Registry.create(registry, "shopping")
		{:ok, bucket} = KV.Registry.lookup(registry, "shopping")
		Agent.stop(bucket)
		assert KV.Registry.lookup(registry, "shopping") == :error
	end


	test "removes bucket on crash", %{registry: registry} do
		
		KV.Registry.create(registry, "shopping")
		{:ok, bucket} = KV.Registry.lookup(registry, "shopping")

		#Stop the bucket with non-normal reason
 		#If a process terminates with a reason different than :normal, 
 		#all linked processes receive an EXIT signal, 
 		#causing the linked process to also terminate unless they are trapping exits.
		Agent.stop(bucket, :shutdown)
		assert KV.Registry.lookup(registry, "shopping") == :error

	end

end