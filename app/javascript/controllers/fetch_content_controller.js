import {Controller} from '@hotwired/stimulus'

export default class extends Controller {

  static values = {
    url: String,
  }

  fetch() {
    fetch(this.urlValue)
      .then(response => response.text())
      .then(html => document.body.insertAdjacentHTML('beforeend', html))
  }

}
