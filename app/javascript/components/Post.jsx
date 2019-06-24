import React from 'react'
import styles from './Post.module'
import Section from './Section';
import Avatar from './Avatar';
import PostActions from './PostActions';

class Post extends React.Component {
  constructor (props) {
    super(props)

    this.state = {
      author: props.author,
      editable: props.editable,
      inEditMode: props.inEditMode,
      actionsExpanded: false,
      sections: props.sections,
      persisted: props.persisted,
    }

    this.onEditBtnClick = this.onEditBtnClick.bind(this)
    this.onDeleteBntClick = this.onDeleteBntClick.bind(this)
  }

  onEditBtnClick(event) {
    alert('edit')
  }

  onDeleteBntClick(event) {
    alert('delete')
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

    let footer
    if(this.state.editable && this.state.inEditMode) {
      footer =
        <footer>
          <a href="#" className="btn btn-primary">Publish</a>
          &nbsp;
          <a href="#" className="btn btn-secondary btn-outline-secondary">Cancel</a>
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
