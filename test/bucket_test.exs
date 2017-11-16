defmodule KV.BucketTest do
	
	use ExUnit.Case, async: true

	#test "stores values by key" do
	#	{:ok, bucket} = start_supervised KV.Bucket
	#	assert KV.Bucket.get(bucket, "milk") === nil
#
	#	KV.Bucket.put(bucket, "milk", 3)
	#	assert KV.Bucket.get(bucket,"milk") === 3
	#end

	#Using callbacks instead
	#setup runs before every test
	setup do
		{:ok, bucket} = start_supervised KV.Bucket
		%{bucket: bucket}
	end

	test "stores values by key", %{bucket: bucket} do
		# `bucket` is now the bucket from the setup block
		assert KV.Bucket.get(bucket, "milk") === nil

		KV.Bucket.put(bucket, "milk", 3)
		assert KV.Bucket.get(bucket, "milk") === 3

	end

	test "adding values and then remove the one in the middle", %{bucket: bucket} do
		KV.Bucket.put(bucket, "oranges", 6)
		KV.Bucket.put(bucket, "candies", 8)
		KV.Bucket.put(bucket, "apples", 2)

		expectedNewBucket = %{
			oranges: 6,
			apples: 2
		}
		
		#Supuestamente Map.pop deberia devolver una tupla {valor, nuevoMapa}
		#assert KV.Bucket.simpleDelete(bucket, "candies") === {8, expectedNewBucket}
		assert KV.Bucket.simpleDelete(bucket, "candies") === 8

	end

end