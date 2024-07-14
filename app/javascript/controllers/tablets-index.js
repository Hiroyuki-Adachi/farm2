import QrScanner from 'qr-scanner';
import * as faceapi from 'face-api.js';
import { Turbo } from "@hotwired/turbo-rails";
import * as tf from '@tensorflow/tfjs';

document.addEventListener('turbo:load', async () => {
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const context = canvas.getContext('2d');

    const qrScanner = new QrScanner(video, result => handleQRCode(result), {
        highlightScanRegion: true,
        highlightCodeOutline: true
    });

    // Face-api.js Authentication Setup
    await faceapi.nets.tinyFaceDetector.loadFromUri('/models');
    await faceapi.nets.faceLandmark68Net.loadFromUri('/models');
    await faceapi.nets.faceRecognitionNet.loadFromUri('/models');

    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
            qrScanner.start();
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

    async function handleQRCode(result) {
        fetch(document.getElementById("sessions_qr_path").value, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            body: JSON.stringify({ qr_code: result.data })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 認証成功時にメニュー画面へ遷移
                Turbo.visit('/menu'); // Turboを使用して遷移
            } else {
                // 認証失敗時の処理
                console.log(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
});
