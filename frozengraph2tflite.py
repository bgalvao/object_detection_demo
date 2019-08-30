# adapted from https://www.tensorflow.org/lite/convert/python_api#exporting_a_graphdef_from_file_

import tensorflow as tf

graph_def_file = "./output/frozen_inference_graph.pb"
input_arrays = ["input"]
output_arrays = ["MobilenetV1/Predictions/Softmax"]

converter = tf.lite.TFLiteConverter.from_frozen_graph(
	graph_def_file,
	#input_arrays,
	#output_arrays,
	input_shapes=None  # inferred
)
tflite_model = converter.convert()
open("converted_model.tflite", "wb").write(tflite_model)