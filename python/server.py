import os
import json
import asyncio
from aiohttp import ClientSession
from PIL import Image
import requests
from io import BytesIO
from quart import Quart, request, jsonify, send_from_directory
from quart_cors import cors
import numpy as np
import aiofiles

app = Quart(__name__)
app = cors(app)

# Get the directory of the current script
current_directory = os.path.dirname(os.path.abspath(__file__))

# Specify the path to the uploads folder relative to the script directory
UPLOAD_FOLDER = os.path.join(current_directory, 'uploads')
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

class_names = ['10150', '10151x', '10250', '10251', '10270', '10271', '10280', '10281', '10290', '10291', '10410', '10411', '10560', '10561', '10780', '10781', '11040', '11041', '11050', '11060', '11061', '11370', '11640', '11641', '11650', '11651', '11660', '11661', '11670', '11671x', '11680', '11681', '11690', '11691', '12390', '12391', '12400', '12410', '12411x', '12420', '12430', '12431', '12440', '5960', '6670', '6700', '6751', '7350', '7351', '7360', '7370', '7371', '7440', '7441', '7480', '7481', '7490', '7500', '7501', '7590', '7600', '7601', '7610', '7611', '7790', '7791', '8300', '8310', '8320', '8321x', '8330', '8331', '8600', '8601', '8610', '8620', '8621x', '8630', '8640', '8650', '8651x', '8661', '8670', '8671', '8680', '8681', '8690x', '8691', '8800', '8801', '8810', '8811', '8820', '8830', '8831x', '8840', '8841', '8850', '8851', '8860', '8861x', '8870', '8880', '8890', '8891', '8900', '8901', '8910', '8911x', '8920', '8921', '8930', '8931', '8940', '8941', '8950', '8990', '8991', '9050', '9051', '9430', '9431', '9440', '9441', '9450', '9451', '9630', '9640', '9641x', '9650', '9651', '9660', '9670', '9750', '9870', '9871', '9880', '9890', '9891x', '9970']


async def send_to_model(image_np):
    data = json.dumps({"signature_name": "serving_default", "instances": image_np.tolist()})
    headers = {"content-type": "application/json"}
    async with ClientSession() as session:
        async with session.post('https://coin-model-7ynk.onrender.com/v1/models/coin_model:predict', data=data, headers=headers) as response:
            return await response.json()

def get_next_index():
    existing_files = [f for f in os.listdir(UPLOAD_FOLDER) if os.path.isfile(os.path.join(UPLOAD_FOLDER, f))]
    existing_images = [f for f in existing_files if f.startswith('image_') and f.endswith('.jpg')]
    if existing_images:
        indexes = [int(img.split('_')[1]) for img in existing_images]
        return max(indexes) + 1
    else:
        return 1
    

print("heheheha!")

@app.route('/upload', methods=['POST'])
async def upload_file():
    if 'file' not in (await request.files):
        return jsonify({"error": "No file part"}), 400
    
    file = (await request.files)['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400
    
    if file:
        # Save the uploaded file with a fixed filename
        filename = 'image.jpg'
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        await file.save(filepath)

        print(f"Image received: {filename}")

        img_height, img_width = 256, 256
        image = Image.open(filepath)

        rotated_image = image.rotate(-90, expand=True)
        rotated_filename = 'rotated_' + filename
        rotated_filepath = os.path.join(UPLOAD_FOLDER, rotated_filename)
        rotated_image.save(rotated_filepath)

        min_dimension = min(rotated_image.width, rotated_image.height)
        left = (rotated_image.width - min_dimension) / 2
        top = (rotated_image.height - min_dimension) / 2
        right = left + min_dimension
        bottom = top + min_dimension
        cropped_rotated_image = rotated_image.crop((left, top, right, bottom))

        cropped_rotated_filename = 'cropped_rotated_' + filename
        cropped_rotated_filepath = os.path.join(UPLOAD_FOLDER, cropped_rotated_filename)
        cropped_rotated_image.save(cropped_rotated_filepath)

        resized_image = cropped_rotated_image.resize((img_width, img_width))

        reduced_quality_filepath = os.path.join(UPLOAD_FOLDER, f"reduced_quality_{filename}")
        reduced_quality_image = resized_image.copy()
        reduced_quality_image.save(reduced_quality_filepath, quality=90)

        with open(reduced_quality_filepath, "rb") as f:
            response = requests.post("https://coinrecognition.onrender.com/preprocess_image/", files={"file": f})

        final_image = Image.open(BytesIO(response.content))

        image_np = np.array(final_image)
        image_np = image_np.reshape((1, img_width, img_width, 3))

        np.save(os.path.join(UPLOAD_FOLDER, "image_np.npy"), image_np)

        predictions = await send_to_model(image_np)
        predicted_class = class_names[np.argmax(predictions['predictions'][0])]

        key = predicted_class[:-1]
        coin_info = requests.get(f"https://coinrecognition.onrender.com/get_info/{key}").json()
        print(coin_info)

        return jsonify({
            "message": "File uploaded successfully",
            "filename": cropped_rotated_filename,
            "reduced_quality_filename": f"reduced_quality_{filename}",
            "predicted_class": predicted_class,
            "coin_info": coin_info
        }), 200


@app.route('/uploads/<filename>')
async def uploaded_file(filename):
    return await send_from_directory(UPLOAD_FOLDER, filename)

if __name__ == '__main__':
    app.run(debug=True, use_reloader=False, host='0.0.0.0')
