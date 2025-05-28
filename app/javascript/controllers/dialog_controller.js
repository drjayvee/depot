import {ClickOutsideController} from 'stimulus-use'

/**
 * @property element HTMLDialogElement
 */
export default class extends ClickOutsideController {
  connect() {
    super.connect()

    this.dispatch('connect')
  }

  // Actions

  show() {
    this.element.show()
  }

  showModal() {
    this.element.showModal()
  }

  close() {
    this.element.close()
  }

  // Events callbacks

  clickOutside() {
    this.close()
  }
}
