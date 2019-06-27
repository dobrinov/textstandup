import React from "react"
import styles from './Item.module'
import Input from './Input';

class Item extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      title: props.title,
      url: props.url,
      description: props.description,
      persisted: props.persisted,
      editable: props.editable,
      inEditMode: props.inEditMode,
    }

    this.onTitleChange = this.onTitleChange.bind(this)
    this.onUrlChange = this.onUrlChange.bind(this)
    this.onDescriptionChange = this.onDescriptionChange.bind(this)
    this.onSubmitBtnClick = this.onSubmitBtnClick.bind(this)
    this.onCancelBtnClick = this.onCancelBtnClick.bind(this)
  }

  onTitleChange(value) {
    this.setState({title: value})
  }

  onUrlChange(value) {
    this.setState({url: value})
  }

  onDescriptionChange(value) {
    this.setState({description: value})
  }

  onSubmitBtnClick(event) {
    event.preventDefault()

    const titleValid = this.state.title && this.state.title.length > 0
    const descriptionValid = this.state.description && this.state.description.length > 0

    if (!titleValid) {
      this.setState({titleError: 'can\'t be empty'})
    }

    if (!descriptionValid) {
      this.setState({descriptionError: 'can\'t be empty'})
    }

    if (titleValid && descriptionValid) {
      this.setState({inEditMode: false})
    }

    this.props.onSubmit(event)
  }

  onCancelBtnClick (event) {
    event.preventDefault()

    this.setState({
      title: '',
      url: '',
      description: '',
      inEditMode: false
    })

    this.props.onCancel(event)
  }

  render () {
    let content

    if (this.state.inEditMode) {
      content =
        <form>
          <Input id="title"
                 required={true}
                 label="Title"
                 placeholder="?"
                 value={this.state.title}
                 error={this.state.titleError}
                 onChange={this.onTitleChange} />

          <Input id="url"
                 required={false}
                 label="Ticket URL"
                 placeholder="?"
                 value={this.state.url}
                 onChange={this.onUrlChange} />

          <Input id="description"
                 type="text"
                 required={true}
                 label="Description"
                 placeholder="?"
                 value={this.state.description}
                 error={this.state.descriptionError}
                 onChange={this.onDescriptionChange}/>

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
