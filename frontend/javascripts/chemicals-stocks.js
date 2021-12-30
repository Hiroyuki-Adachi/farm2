
window.addEventListener("load", () => {
    loadChemical(document.getElementById("term").value, document.getElementById("chemical_type").value);

    document.getElementById("term").addEventListener("change", (event) => {
        loadChemical(event.target.value, document.getElementById("chemical_type").value);
    });
    document.getElementById("chemical_type").addEventListener("change", (event) => {
        loadChemical(document.getElementById("term").value, event.target.value);
    });
    document.getElementById("search").addEventListener("click", (event) => {
        search(document.getElementById("chemical_id").value);
    });
});

function loadChemical(term, chemicalType)
{
    fetch(`${document.getElementById("load_path").value}?term=${term}&chemical_type_id=${chemicalType}`)
    .then((data) => data.text())
    .then((html) => {
        document.getElementById("chemical_id").innerHTML = html;
    });
}

function search(chemicalTerm)
{
    fetch(document.getElementById("search_path").value.replace('0', chemicalTerm))
    .then((data) => data.text())
    .then((html) => {
        document.getElementById("search_result").innerHTML = html;
    });
}
