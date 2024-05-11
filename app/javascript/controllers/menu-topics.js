import { Modal } from "bootstrap";

document.addEventListener('turbo:load', function () {
    document.addEventListener('turbo:before-stream-render', (event) => {
        const myModal = new Modal(document.getElementById('topic_data_modal'));
        myModal.show();
    });
    document.getElementById("topic_data_modal").addEventListener("hidden.bs.modal", (event) => {
        fetch(document.getElementById("topic_data_dialog").dataset.url, {
            method: 'delete',
            headers: {
                'X-CSRF-Token': getCsrfToken()
            }
        }).then(response => {
            if (response.ok) {
                return response.text();
            } else {
                console.error('Error deleting topic data');
            }
        }).then(html => {
            document.getElementById("topics_content").innerHTML = html;
        })
    });
});

const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
        if (meta.getAttribute('name') === 'csrf-token') {
            return meta.getAttribute('content');
        }
    }
    return '';
};
