import React from 'react'
import styles from './Post.module'
import Section from './Section';
import Avatar from './Avatar';
import PostActions from './PostActions';
import PostSubmitBtn from './PostSubmitBtn';

class Post extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      id: props.id,
      author: props.author,
      editable: props.editable,
      inEditMode: props.inEditMode,
      submissionAllowed: true,
      actionsExpanded: false,
      sections: props.sections,
      persisted: props.persisted,
    }

    this.onEditBtnClick = this.onEditBtnClick.bind(this)
    this.onDeleteBntClick = this.onDeleteBntClick.bind(this)
    this.onSubmitBntClick = this.onSubmitBntClick.bind(this)
    this.onCancelBtnClick = this.onCancelBtnClick.bind(this)
  }

  onEditBtnClick(event) {
    event.preventDefault()
    alert('edit')
  }

  onDeleteBntClick(event) {
    event.preventDefault()
    alert('delete')
  }

  onSubmitBntClick(event) {
    this.props.onPostSubmit(event)
  }

  onCancelBtnClick(event) {
    event.preventDefault()

    this.setState({
      inEditMode: false,
      submissionAllowed: false,
      actionsExpanded: false,
    })

    this.props.onPostCancelation(event, this.state.id, this.state.persisted)
  }

  render() {
    const sections =
      this.state.sections.map((section) =>
        <Section key={section.key}
                 title={section.title}
                 items={section.items}
                 inEditMode={this.state.inEditMode} />
      )

    let postActions;
    if(this.state.editable && this.state.persisted) {
      postActions =
        <PostActions expanded={false}
                     onEditBtnClick={this.onEditBtnClick}
                     onDeleteBtnClick={this.onDeleteBntClick} />
    }

    let submitBtnText
    if (this.state.persisted) {
      submitBtnText = 'Save'
    } else {
      submitBtnText = 'Publish'
    }

    let footer
    if(this.state.editable && this.state.inEditMode) {
      footer =
        <footer>
          <PostSubmitBtn text={submitBtnText}
                         enabled={this.state.submissionAllowed}
                         loading={false}
                         onClick={this.onSubmitBntClick} />
          &nbsp;
          <a href="#" className="btn btn-secondary btn-outline-secondary" onClick={this.onCancelBtnClick}>Cancel</a>
        </footer>
    }

    return (
      <div className={styles.container}>
        <header>
          <div className={styles.avatar}>
            <Avatar initials={this.state.author.initials} />
          </div>
          <div className={styles.details}>
            <h3>{this.state.author.name}</h3>
            <span>{this.state.publishedAt}</span>
          </div>
          {postActions}
        </header>
        <section className={styles.content}>
          {sections}
        </section>
        {footer}
      </div>
    )
  }
}

export default Post
