import * as tf from '@tensorflow/tfjs';
import * as faceapi from 'face-api.js';
const video = document.getElementById('face');
const startCaptureButton = document.getElementById('start_capture');
const stopCameraButton = document.getElementById('stop_camera');
let captureInterval;
const faceDescriptors = [];
let stream;

async function captureFace() {
    const detection = await faceapi.detectSingleFace(video).withFaceLandmarks().withFaceDescriptor();
    if (detection) {
        console.log('Face captured');

        // サーバーに顔情報を送信
        const response = await fetch(document.getElementById("face_create_path").value, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({ face_descriptor: detection.descriptor }),
        });
    
        const result = await response.json();
        console.log(result.status);
    } else {
        console.log('No face detected');
    }
}

async function startCapture() {
    startCaptureButton.disabled = true;
    if (video.srcObject === null) {
        stream = await navigator.mediaDevices.getUserMedia({ video: {} });
        video.srcObject = stream;
    }
    captureInterval = setInterval(captureFace, 2000); 
}

function stopCamera() {
    clearInterval(captureInterval);
    if (stream) {
        const tracks = stream.getTracks();
        tracks.forEach(track => track.stop());
        video.srcObject = null;
        console.log('Camera stopped');
    }
    startCaptureButton.disabled = false;
}

window.addEventListener('turbo:load', async () => {
    const MODEL_URL = 'https://raw.githubusercontent.com/justadudewhohacks/face-api.js/master/weights';
    await faceapi.nets.ssdMobilenetv1.loadFromUri(MODEL_URL);
    await faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL);
    await faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL);
    startCaptureButton.addEventListener('click', startCapture);
    stopCameraButton.addEventListener('click', stopCamera);
});
