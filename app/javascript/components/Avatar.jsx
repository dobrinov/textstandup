import React from "react"
import styles from './Avatar.module'

class Avatar extends React.Component {
  render() {
    return (
      <div className={styles.avatar}>
        {this.props.initials}
      </div>
    )
  }
}

export default Avatar
