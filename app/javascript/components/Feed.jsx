import React from "react"
import styles from './Feed.module'
import EmptyFeedPoster from './EmptyFeedPoster';
import Post from './Post';
import NewPostTypeSelectionPrompt from './NewPostTypeSelectionPrompt'

class Feed extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      postingAllowed: props.postingAllowed,
      newPostTypeSelectionPromptVisible: false,
      posts: props.posts
    }

    this.onNewPostBtnClick = this.onNewPostBtnClick.bind(this)
    this.onNewMorningReportBtnClick = this.onNewMorningReportBtnClick.bind(this)
    this.onNewDeliveryReportBtnClick = this.onNewDeliveryReportBtnClick.bind(this)
  }

  onNewPostBtnClick(event) {
    this.setState({
      newPostTypeSelectionPromptVisible: true
    })
  }

  onNewMorningReportBtnClick(event) {
    const post = {
      key: 'draft',
      editable: true,
      inEditMode: true,
      author: {
        name: 'Didko Banditko',
        initials: 'DB',
      },
      sections: [
        {title: 'Current progress', key: 'progress', items: []},
        {title: 'Plan for the day', key: 'plan', items: []},
        {title: 'Blockers', key: 'blockers', items: []},
        {title: 'Announcements', key: 'announcements', items: []},
      ]
    }

    this.setState({
      newPostTypeSelectionPromptVisible: false,
      posts: [post]
    })
  }

  onNewDeliveryReportBtnClick(event) {
    const post = {
      key: 'draft',
      editable: true,
      inEditMode: true,
      author: {
        name: 'Didko Banditko',
        initials: 'DB',
      },
      sections: [
        {title: 'Delivered', items: []},
      ]
    }

    this.setState({
      newPostTypeSelectionPromptVisible: false,
      posts: [post]
    })
  }

  render() {
    const posts =
      this.state.posts.map((post) =>
        <Post key={post.key}
              author={post.author}
              publishedAt={post.published_at}
              sections={post.sections}
              persisted={post.persisted}
              editable={post.editable}
              inEditMode={post.inEditMode} />
      )

    let header
    if(this.state.newPostTypeSelectionPromptVisible) {
      header = <NewPostTypeSelectionPrompt onNewMorningReportBtnClick={this.onNewMorningReportBtnClick}
                                           onNewDeliveryReportBtnClick={this.onNewDeliveryReportBtnClick} />
    } else {
      if(posts.length > 0) {
        if(this.state.postingAllowed) {
          header =
            <a onClick={this.onNewPostBtnClick} href="#" className="btn btn-outline-primary btn-lg mb-3" title="Post a new report">
              <i className="fas fa-plus"></i>
            </a>
        }
      } else {
        header = <EmptyFeedPoster postingAllowed={this.state.postingAllowed}
                                  onNewPostBtnClick={this.onNewPostBtnClick}/>
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
