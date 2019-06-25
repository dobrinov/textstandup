import React from 'react'

class PostSubmitBtn extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      text: props.text,
      loading: props.loading,
      enabled: props.enabled,
    }

    this.onClick = this.onClick.bind(this)
  }

  onClick(event) {
    event.preventDefault()
    this.props.onClick(event)
  }

  render() {
    let classNames

    if (this.state.enabled) {
      classNames = 'btn btn-primary'
    } else {
      classNames = 'btn btn-outline-primary disabled'
    }

    let text
    if (this.state.loading) {
      text = <i className="fas fa-sync-alt fa-spin"></i>
    } else {
      text = this.state.text
    }

    return (
      <a href="#" className={classNames} onClick={this.onClick}>{text}</a>
    )
  }
}

export default PostSubmitBtn
