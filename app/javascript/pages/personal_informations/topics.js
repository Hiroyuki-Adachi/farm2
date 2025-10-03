export const init = () => {
    document.querySelectorAll("a.topic-link").forEach(link => {
        link.addEventListener("click", (event) => {
            event.preventDefault();
            fetch(link.dataset.readed, {
                method: "PATCH",
                headers: {
                    "X-CSRF-Token": getCsrfToken()
                },
                keepalive: true 
            })
            .then(() => window.open(link.href, '_blank'))
            .catch(() => window.open(link.href, '_blank'))
            .finally(() => Turbo.visit(window.location.href, { action: 'replace' }));
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
