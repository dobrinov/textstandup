import React from "react"
import styles from './Item.module'

class Item extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      title: props.title,
      url: props.url || '',
      description: props.description,
      editable: props.editable,
      inEditMode: true, //props.inEditMode,
    }

    this.onTitleInput = this.onTitleInput.bind(this)
    this.onUrlInput = this.onUrlInput.bind(this)
    this.onDescriptionInput = this.onDescriptionInput.bind(this)
    this.onSubmitBtnClick = this.onSubmitBtnClick.bind(this)
    this.onCancelBtnClick = this.onCancelBtnClick.bind(this)
  }

  onTitleInput (event) {
    this.setState({title: event.target.value})
  }

  onUrlInput (event) {
    this.setState({url: event.target.value})
  }

  onDescriptionInput (event) {
    this.setState({description: event.target.value})
  }

  onSubmitBtnClick (event) {
    event.preventDefault()
    alert('submit')
  }

  onCancelBtnClick (event) {
    event.preventDefault()
    this.setState({inEditMode: false})
  }

  render () {
    let content

    if (this.state.inEditMode) {
      content =
        <form>
          <div className="form-group">
            <label htmlFor="title">
              Title
              <abbr title="required">*</abbr>
            </label>
            <input type="text"
                   className="form-control"
                   id="title"
                   placeholder="?"
                   value={this.state.title}
                   onChange={this.onTitleInput} />
          </div>
          <div className="form-group">
            <label htmlFor="url">Ticket URL</label>
            <input type="text"
                   className="form-control"
                   id="url"
                   placeholder="?"
                   value={this.state.url}
                   onChange={this.onUrlInput} />
          </div>
          <div className="form-group">
            <label htmlFor="description">
              Description
              <abbr title="required">*</abbr>
            </label>
            <textarea className="form-control"
                      id="description"
                      placeholder="?"
                      rows="5"
                      value={this.state.description}
                      onChange={this.onDescriptionInput} />
          </div>
          <div className="form-group">
            <input type="submit" value="Add" className="btn btn-primary" onClick={this.onSubmitBtnClick} />
            &nbsp;
            <input type="reset" value="Cancel" className="btn btn-outline-secondary" onClick={this.onCancelBtnClick} />
          </div>
        </form>
    } else {
      content =
        <div>
          <h6>{this.state.title}</h6>
          <a href={this.state.url} target="_blank">{this.state.url}</a>
          <p>{this.state.description}</p>
        </div>
    }

    return (
      <div className={styles.item}>
        {content}
      </div>
    )
  }
}

export default Item
