import React from "react"
import styles from './Feed.module'
import EmptyFeedPoster from './EmptyFeedPoster';
import Post from './Post';
import NewPostTypeSelectionPrompt from './NewPostTypeSelectionPrompt'

class Feed extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      user: props.user,
      postingAllowed: props.postingAllowed,
      newPostBtnVisible: true, //props.newPostBtnVisible,
      newPostTypeSelectionPromptVisible: false,
      posts: props.posts
    }

    this.onNewPostBtnClick = this.onNewPostBtnClick.bind(this)
    this.onNewMorningReportBtnClick = this.onNewMorningReportBtnClick.bind(this)
    this.onNewDeliveryReportBtnClick = this.onNewDeliveryReportBtnClick.bind(this)
    this.onPostSubmit = this.onPostSubmit.bind(this)
    this.onPostCancelation = this.onPostCancelation.bind(this)
  }

  onNewPostBtnClick(event) {
    this.setState({
      newPostTypeSelectionPromptVisible: true
    })
  }

  onNewMorningReportBtnClick(event) {
    const newPost = {
      id: 'draft',
      editable: true,
      inEditMode: true,
      author: {
        name: this.state.user.name,
        initials: this.state.user.initials,
      },
      sections: [
        {title: 'Current progress', key: 'progress', items: []},
        {title: 'Plan for the day', key: 'plan', items: []},
        {title: 'Blockers', key: 'blockers', items: []},
        {title: 'Announcements', key: 'announcements', items: []},
      ]
    }

    this.setState({
      newPostBtnVisible: false,
      newPostTypeSelectionPromptVisible: false,
      posts: [newPost, ...this.state.posts],
    })
  }

  onNewDeliveryReportBtnClick(event) {
    const newPost = {
      id: 'draft',
      editable: true,
      inEditMode: true,
      author: {
        name: this.state.user.name,
        initials: this.state.user.initials,
      },
      sections: [
        {title: 'Delivered', items: []},
      ]
    }

    this.setState({
      newPostBtnVisible: false,
      newPostTypeSelectionPromptVisible: false,
      posts: [newPost, ...this.state.posts],
    })
  }

  onPostSubmit(event) {
    alert('submit')
  }

  onPostCancelation(event, id, persisted) {
    if(!persisted) {
      this.setState({
        newPostBtnVisible: true,
        newPostTypeSelectionPromptVisible: false,
        posts: this.state.posts.filter(el => el.id != id)
      })
    }
  }

  render() {
    let posts =
      this.state.posts.map((post) =>
        <Post key={post.id}
              id={post.id}
              author={post.author}
              publishedAt={post.published_at}
              sections={post.sections}
              persisted={post.persisted}
              editable={post.editable}
              inEditMode={post.inEditMode}
              onPostSubmit={this.onPostSubmit}
              onPostCancelation={this.onPostCancelation} />
      )

    let header
    if(this.state.newPostTypeSelectionPromptVisible) {
      header = <NewPostTypeSelectionPrompt onNewMorningReportBtnClick={this.onNewMorningReportBtnClick}
                                           onNewDeliveryReportBtnClick={this.onNewDeliveryReportBtnClick} />
    } else {
      if(posts.length > 0) {
        if(this.state.newPostBtnVisible) {
          header =
            <a onClick={this.onNewPostBtnClick} href="#" className="btn btn-outline-primary btn-lg mb-3" title="Post a new report">
              <i className="fas fa-plus"></i>
            </a>
        }
      } else {
        header = <EmptyFeedPoster postingAllowed={this.state.postingAllowed}
                                  onNewPostBtnClick={this.onNewPostBtnClick} />
      }
    }

    return (
      <div className={styles.feed}>
        {header}
        {posts}
      </div>
    )
  }
}

export default Feed
