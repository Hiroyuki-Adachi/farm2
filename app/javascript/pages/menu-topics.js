export const init = () => {
    document.querySelectorAll("a.topic-link").forEach(link => {
        link.addEventListener("click", (event) => {
            event.preventDefault();
            fetch(link.dataset.readed, {
                method: "DELETE",
                headers: {
                    "X-CSRF-Token": getCsrfToken()
                },
                keepalive: true 
            })
            .then((data) => data.text())
            .then((html) => document.getElementById("topics_content").innerHTML = html)
            .finally(() => window.open(link.href, '_blank'));
        });
    });
};

const getCsrfToken = () => {
    const metas = document.getElementsByTagName('meta');
    for (let meta of metas) {
        if (meta.getAttribute('name') === 'csrf-token') {
            return meta.getAttribute('content');
        }
    }
    return '';
};
