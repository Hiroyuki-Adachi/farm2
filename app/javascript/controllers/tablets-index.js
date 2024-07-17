import QrScanner from 'qr-scanner';
import * as faceapi from 'face-api.js';
import { Turbo } from "@hotwired/turbo-rails";
import * as tf from '@tensorflow/tfjs';
const MODEL_URL = '/models';

document.addEventListener('turbo:load', async () => {
    const video = document.getElementById('video');
    const canvas = document.getElementById('canvas');
    const context = canvas.getContext('2d');
    const menuUrl = document.getElementById('tablets_menu_path').value;

    const qrScanner = new QrScanner(video, result => handleQRCode(result), {
        highlightScanRegion: true,
        highlightCodeOutline: true
    });

    // Face-api.js Authentication Setup
    await faceapi.nets.ssdMobilenetv1.loadFromUri(MODEL_URL);
    await faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL);
    await faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL);

    // カメラSetup
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
            scanFace();
        }, 1000); // 1秒ごとに処理を実行
    }

    // QRコード認証処理
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
                    Turbo.visit(menuUrl);
                } else {
                    // 認証失敗時の処理
                    console.log(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    // 顔認証処理
    async function scanFace() {
        const detection = await faceapi.detectSingleFace(video).withFaceLandmarks().withFaceDescriptor();

        if (detection) {
            console.log('face detected');

            // サーバーに顔情報を送信
            fetch(document.getElementById("sessions_face_path").value, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify({ face_descriptor: detection.descriptor }),
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 認証成功時にメニュー画面へ遷移
                        Turbo.visit(menuUrl); 
                    } else {
                        // 認証失敗時の処理
                        console.log(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }
    }
});
