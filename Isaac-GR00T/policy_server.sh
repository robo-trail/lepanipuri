python scripts/inference_service.py \
    --server \
    --model_path ./checkpoint-15000 \
    --embodiment-tag new_embodiment \
    --data-config so100_dual_arm_triadcam \
    --denoising-steps 2


# working params - 6:14: oct:25
# python scripts/inference_service.py \
#     --server \
#     --model_path ./checkpoint-15000 \
#     --embodiment-tag new_embodiment \
#     --data-config so100_dual_arm_triadcam \
#     --denoising-steps 6