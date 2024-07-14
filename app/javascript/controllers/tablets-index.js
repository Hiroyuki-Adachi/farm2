import QrScanner from 'qr-scanner';
import * as faceapi from 'face-api.js';

document.addEventListener('turbo:load', async () => {
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const context = canvas.getContext('2d');

    const qrScanner = new QrScanner(video, result => handleQRCode(result));
    qrScanner.start();

    // Face-api.js Authentication Setup
    // await faceapi.nets.tinyFaceDetector.loadFromUri('/models');
    // await faceapi.nets.faceLandmark68Net.loadFromUri('/models');
    // await faceapi.nets.faceRecognitionNet.loadFromUri('/models');

    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
            processVideoStream();
        })
        .catch(err => {
            console.error("Error accessing the camera: " + err);
        });

    async function processVideoStream() {
        setInterval(async () => {
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
        }, 1000); // 1秒ごとに処理を実行
    }
});
