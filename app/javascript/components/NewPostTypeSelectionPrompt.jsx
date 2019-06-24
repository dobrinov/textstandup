import React from 'react'
import styles from './NewPostTypeSelectionPrompt.module'

class NewPostTypeSelectionPrompt extends React.Component {
  constructor(props) {
    super(props)

    this.onNewMorningReportBtnClick = this.onNewMorningReportBtnClick.bind(this)
    this.onNewDeliveryReportBtnClick = this.onNewDeliveryReportBtnClick.bind(this)
  }

  onNewMorningReportBtnClick(event) {
    this.props.onNewMorningReportBtnClick()
  }

  onNewDeliveryReportBtnClick(event) {
    this.props.onNewDeliveryReportBtnClick()
  }

  render() {
    return (
      <div className={styles.wrapper}>
        <i className="fas fa-feather-alt"></i>
        <h2>Post a new report</h2>
        <p>What kind of report you want to post?</p>

        <ul>
          <li>
            <a href="#" onClick={this.onNewMorningReportBtnClick}>
              <i className="fas fa-coffee"></i>
              <span>Morning report</span>
            </a>
          </li>
          <li>
            <a href="#" onClick={this.onNewDeliveryReportBtnClick}>
              <i className="fas fa-truck"></i>
              <span>Delivery report</span>
            </a>
          </li>
        </ul>
      </div>
    )
  }
}

export default NewPostTypeSelectionPrompt
