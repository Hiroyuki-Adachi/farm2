import AutoComplete from "@tarekraafat/autocomplete.js";

function q(sel) { return document.querySelector(sel); }

export const init = async () => {
  const input = q("#land");
  const hiddenLandId = q("#land_term_mark_land_id");
  const autocompletePath = q("#autocomplete_land_term_marks_path");

  if (!input || !hiddenLandId || !autocompletePath) return;

  new AutoComplete({
    data: {
      src: fetch(autocompletePath.value).then(r => r.json()),
      keys: ["place", "area"],
      cache: true,
    },
    selector: "#land",
    threshold: 2,
    resultsList: { maxResults: 20 },
    resultItem: {
      element: (item, data) => {
        const escapeHtml = (value) => String(value).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
        item.innerHTML = `${escapeHtml(data.value.place)}(${escapeHtml(data.value.owner)})(${escapeHtml(data.value.area)})`;
      },
      highlight: true,
    },
    events: {
      input: {
        selection: (event) => {
          const land = event.detail.selection.value;
          input.value = `${land.place}(${land.owner})(${land.area})`;
          hiddenLandId.value = land.id;
        },
      },
    },
  });

  input.addEventListener("input", () => {
    hiddenLandId.value = "";
  });
};
