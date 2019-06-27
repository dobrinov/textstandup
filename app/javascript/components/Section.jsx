import React from "react"
import styles from './Section.module'
import Item from './Item';

class Section extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      title: props.title,
      inEditMode: props.inEditMode,
      items: props.items,
    }

    this.onNewItemBtnClick = this.onNewItemBtnClick.bind(this)
    this.onItemSubmit = this.onItemSubmit.bind(this)
    this.onItemCancel = this.onItemCancel.bind(this)
  }

  onNewItemBtnClick(event) {
    event.preventDefault()

    const newItem =
      {
        id: 'draft',
        title: '',
        url: '',
        description: '',
        persisted: false,
        editable: true,
        inEditMode: true,
      }

    this.setState({
      items: [...this.state.items, newItem],
    })
  }

  onItemSubmit(event) {
    alert('ok')
  }

  onItemCancel(event) {
    alert('ok')
  }

  componentDidMount() {
    $('[data-toggle="tooltip"]').tooltip()
  }

  componentDidUpdate(prevProps) {
    $('[data-toggle="tooltip"]').tooltip()

    if(prevProps.inEditMode != this.props.inEditMode) {
      this.setState({inEditMode: this.props.inEditMode})
    }
  }

  render() {
    const items =
      this.state.items.map((item) =>
        <Item key={item.id}
              title={item.title}
              url={item.url}
              description={item.description}
              editable={item.editable}
              inEditMode={item.inEditMode}
              onSubmit={this.onItemSubmit}
              onCancel={this.onItemCancel} />
      )

    let newItemBtn
    if (this.state.inEditMode) {
      newItemBtn =
        <a onClick={this.onNewItemBtnClick} data-toggle="tooltip" title="?">
          <i className="fas fa-plus"></i>
        </a>
    }

    return (
      <div className={styles.section}>
        <h5>{this.state.title}</h5>
        {items}
        {newItemBtn}
      </div>
    )
  }
}

export default Section
