import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['fieldset']

  update(e) {
    const paymentType = e.target.value

    this.fieldsetTargets.forEach(fieldset => {
      const matchingType = fieldset.dataset.paymentType === paymentType

      fieldset.hidden = !matchingType
      fieldset.querySelector('input').required = matchingType
    })
  }
}
