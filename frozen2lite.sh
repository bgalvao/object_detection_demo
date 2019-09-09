# installed bazel in a new conda env

INPUT_FILE=./tf_files/tflite_graph.pb
OUTPUT_FILE=./tf_files/detect.tflite

INPUT_ARRAYS=normalized_input_image_tensor
OUTPUT_ARRAYS='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3'

# pick one
#INFERENCE_TYPE=QUANTIZED_UINT8
INFERENCE_TYPE=FLOAT


if [ ! -d tensorflow ]; then
    echo "tensorflow clone not yet here. cloning it..."
    git clone https://github.com/tensorflow/tensorflow --depth 1
fi

cd tensorflow

if [ ! -f WORKSPACE ]; then
    touch WORKSPACE
fi


if [ ! -d ./bazel-bin ]; then # have you compiled TOCO yet?
    # Take action if $DIR exists. #
    echo "\n\nBuilding TOCO with bazel + attempting compiling to TFLite\n\n"
  
    exit 1
    bazel run -c opt tensorflow/lite/toco:toco -- \
        --input_file=$INPUT_FILE \
        --output_file=$OUTPUT_FILE \
        --input_shapes=1,300,300,3 \
        --input_arrays=normalized_input_image_tensor \
        --output_arrays=$OUTPUT_ARRAYS \
        --mean_values=128 \
        --std_values=128 \
        --inference_type=$INFERENCE_TYPE \
        --change_concat_input_ranges=false \
        --allow_custom_ops

else
    echo -e "\n\nIt seems that TOCO is built. Skipping to compiling to TFLite\n\n"
    echo $INPUT_FILE
        ./bazel-bin/tensorflow/lite/toco/toco \
            --input_file=$INPUT_FILE \
            --output_file=$OUTPUT_FILE \
            --input_shapes=1,300,300,3 \
            --input_arrays=$INPUT_ARRAYS \
            --output_arrays=$OUTPUT_ARRAYS \
            --mean_values=128 \
            --std_values=128 \
            --change_concat_input_ranges=false \
            --inference_type=$INFERENCE_TYPE \
            --allow_custom_ops

    echo -e "\n\n -> if this failed, you can always try without QUANTIZED_UINT8"
fi
