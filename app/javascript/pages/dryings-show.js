export const init = () => {
    document.querySelectorAll("#drying-detail td").forEach((element) => {
        element.addEventListener("click", (event) => {
            Turbo.visit(event.target.dataset.drying);
        });
    });

    document.querySelectorAll("#drying-detail td").forEach(cell => {
        cell.addEventListener("mouseenter", () => {
            const index = cell.cellIndex + 1;
            document.querySelectorAll(`#drying-detail td:nth-child(${index})`)
            .forEach(c => c.classList.add("highlight"));
        });

        cell.addEventListener("mouseleave", () => {
            const index = cell.cellIndex + 1;
            document.querySelectorAll(`#drying-detail td:nth-child(${index})`)
            .forEach(c => c.classList.remove("highlight"));
        });
    });
};
