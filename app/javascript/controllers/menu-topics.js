import { Modal } from "bootstrap";

document.addEventListener('turbo:load', function () {
    document.addEventListener('turbo:before-stream-render', (event) => {
        const myModal = new Modal(document.getElementById('topic_data_modal'));
        myModal.show();

        document.getElementById("topic_data_modal").addEventListener("hidden.bs.modal", () => {
            fetch(document.getElementById("topic_data_dialog").dataset.url, {
                method: 'delete',
                headers: {
                    'X-CSRF-Token': getCsrfToken()
                }
            }).then(response => {
                if (!response.ok) {
                    throw new Error('Error deleting topic data');
                }
                return response.text();
            }).then(html => {
                document.getElementById("topics_content").innerHTML = html;
            }).catch(error => {
                console.error(error.message);
            });
        });
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
