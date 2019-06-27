import React from "react"

class Input extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      id: props.id,
      type: props.type,
      required: props.required,
      label: props.label,
      placeholder: props.placeholder,
      value: props.value,
      error: props.error,
    }

    this.onChange = this.onChange.bind(this)
  }

  onChange(event) {
    const value = event.target.value
    this.setState({value: value})
    this.props.onChange(value)
  }

  componentDidUpdate(prevProps) {
    if(prevProps.error != this.props.error) {
      this.setState({error: this.props.error})
    }
  }

  render () {
    let required
    if (this.state.required) {
      required = <abbr title="required">*</abbr>
      }

    let classNames = 'form-control'
    let validationError
    if (this.state.error) {
      classNames += ' is-invalid'
      validationError =
        <div className="invalid-feedback">
          {this.state.error}
        </div>
    }

    let input
    if(this.state.type == 'text') {
      input =
        <textarea className={classNames}
                  id={this.state.id}
                  placeholder={this.state.placeholder}
                  rows="5"
                  value={this.state.value}
                  onChange={this.onChange} />

    } else {
      input =
        <input type="text"
               className={classNames}
               id={this.state.id}
               placeholder={this.state.placeholder}
               value={this.state.value}
               autoComplete="off"
               onChange={this.onChange} />
    }

    return (
      <div className="form-group">
        <label htmlFor={this.state.id}>
          {this.state.label}
          {required}
        </label>
        {input}
        {validationError}
      </div>
    )
  }
}

export default Input
