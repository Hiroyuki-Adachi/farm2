import { Modal } from "bootstrap";

document.addEventListener('turbo:load', function () {
    document.addEventListener('turbo:before-stream-render', (event) => {
        console.log('turbo:before-stream-render');
        if (document.getElementById('topic_data_modal')) {
            const myModal = new Modal(document.getElementById('topic_data_modal'));
            myModal.show();
        }
    });
});
