import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "quantity" ]
  
  quantityMinus(evt) {
    evt.preventDefault();
    let q = Number(this.quantityTarget.value);
    if (q > 1) {
      this.quantityTarget.value = q - 1;
    }
  }

  quantityPlus(evt) {
    evt.preventDefault();
    let q = Number(this.quantityTarget.value);
    this.quantityTarget.value = q + 1;
  }

  o(evt) {
    evt.preventDefault();
    console.log('hola');
  }
}