import { Controller } from "@hotwired/stimulus"
window.changeManagePrice = function(element) {
  const area = new Decimal(document.getElementById(`area_${element.dataset.id}`).innerText);
  const price = new Decimal(element.value);
  document.getElementById(`manage_fee_${element.dataset.id}`).value = area.mul(price).div(10).toFixed(0);
  calcSumManage();
}

window.changeManageFee = function(element) {
  const area = new Decimal(document.getElementById(`area_${element.dataset.id}`).innerText);
  const fee = new Decimal(element.value);
  document.getElementById(`manage_price_${element.dataset.id}`).value = fee.div(area.div(10)).toFixed(0);
  calcSumManage();
}

window.changePeasantPrice = function(element) {
  const area = new Decimal(document.getElementById(`area_${element.dataset.id}`).innerText);
  const price = new Decimal(element.value);
  document.getElementById(`peasant_fee_${element.dataset.id}`).value = area.mul(price).div(10).toFixed(0);
  calcSumPeasant();
}

window.changePeasantFee = function(element) {
  const area = new Decimal(document.getElementById(`area_${element.dataset.id}`).innerText);
  const fee = new Decimal(element.value);
  document.getElementById(`peasant_price_${element.dataset.id}`).value = fee.div(area.div(10)).toFixed(0);
  calcSumPeasant();
}

function calcSumManage()
{
  let amount = new Decimal(0);
  document.querySelectorAll("input[name$='[manage_fee]']").forEach(e => {
    amount = amount.plus(new Decimal(e.value));
  });
  document.getElementById("sum_manage_fee").innerText = amount.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

function calcSumPeasant()
{
  let amount = new Decimal(0);
  document.querySelectorAll("input[name$='[peasant_fee]']").forEach(e => {
    amount = amount.plus(new Decimal(e.value));
  });
  document.getElementById("sum_peasant_fee").innerText = amount.toFixed(0).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

export default class extends Controller {}
