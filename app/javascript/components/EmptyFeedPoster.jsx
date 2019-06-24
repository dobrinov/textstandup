import React from "react"
import styles from './EmptyFeedPoster.module'

class EmptyFeedPoster extends React.Component {
  constructor(props) {
    super(props)
    this.postingAllowed = props.postingAllowed
    this.onNewPostBtnClick = this.onNewPostBtnClick.bind(this)
  }

  onNewPostBtnClick(event) {
    event.preventDefault()
    this.props.onNewPostBtnClick()
  }

  render() {
    let newPostBtn
    if(this.postingAllowed) {
      newPostBtn =
        <a onClick={this.onNewPostBtnClick} href="#" className="btn btn-primary">
          Post a new report
        </a>
    }

    return (
      <div className={styles.wrapper + ' alert alert-info'}>
        <i className="fas fa-umbrella-beach"></i>
        <h2>No reports today</h2>
        <p>Sorry, no reports have been posted on this date.</p>
        {newPostBtn}
      </div>
    )
  }
}

export default EmptyFeedPoster
