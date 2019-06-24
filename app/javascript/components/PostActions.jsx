import React from "react"

class PostActions extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      expanded: props.expanded
    }

    this.onEditBtnClick = this.onEditBtnClick.bind(this)
    this.onDeleteBtnClick = this.onDeleteBtnClick.bind(this)
    this.onToggleBtnClick = this.onToggleBtnClick.bind(this)
  }

  onEditBtnClick(event) {
    event.preventDefault()
    this.props.onEditBtnClick()
  }

  onDeleteBtnClick(event) {
    event.preventDefault()
    this.props.onDeleteBtnClick()
  }

  onToggleBtnClick(event) {
    event.preventDefault()
    this.setState({expanded: !this.state.expanded})
  }

  render() {
    let buttons
    if (this.state.expanded) {
      buttons =
        <div className="btn-group">
          <a onClick={this.onEditBtnClick} href="#" className="btn btn-sm btn-outline-dark">
            <i className="fas fa-pencil-alt"></i>
          </a>
          <a onClick={this.onDeleteBtnClick} href="#" className="btn btn-sm btn-outline-danger">
            <i className="fas fa-times"></i>
          </a>
          <a onClick={this.onToggleBtnClick} href="#" className="btn btn-sm btn-outline-secondary">
            <i className="fas fa-ellipsis-h"></i>
          </a>
        </div>
    } else {
      buttons =
        <a onClick={this.onToggleBtnClick} href="#" className="btn btn-sm btn-outline-secondary">
          <i className="fas fa-ellipsis-h"></i>
        </a>
    }

    return (<div>{buttons}</div>)
  }
}

export default PostActions
