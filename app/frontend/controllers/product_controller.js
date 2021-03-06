import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "quantity", "sku", "addToCartButton" ]

  addToCart(evt) {
    evt.preventDefault();
    
    let product_id = this.data.get("id");
    let quantity = this.quantityTarget.value;
    let sku = this.skuTarget.value;

    if (quantity > 0) {
      this.addToCartButtonTarget.classList.add('spinner-grow', 'text-white');
      this.addToCartButtonTarget.innerHTML = '';

      let data = new FormData();
      data.append("id", product_id);
      data.append("quantity", quantity);
      data.append("sku", sku);

      Rails.ajax({
        url: "/api/v1/cart",
        data,
        type: "POST",
        success: resp => {
          if (resp.status === 'ok') {
            let item_count = resp.items || 0;
            // post event
            let evt = new CustomEvent('addToCart', {'detail': {item_count} });
            document.dispatchEvent(evt);
          }
        },
        error: err => {
          console.log(err);
        },
        complete: () => {
          this.addToCartButtonTarget.classList.remove('spinner-grow', 'text-white');
          this.addToCartButtonTarget.innerHTML = 'Add To Cart';
        }
      });
    }
    
  }
  
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

  
}