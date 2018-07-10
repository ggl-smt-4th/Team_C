import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employee extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    this.checkEmployee();
  }

  checkEmployee = () => {
    const {payroll,employee} =this.props;
    payroll.employees.call('0xa89efed3025c88704ffb994a58303be3f7e23871',{
      from:'0xa89efed3025c88704ffb994a58303be3f7e23871',
      gas:1000000
    }).then(result=>{
      this.setState({
          salary:result[1].toNumber(),
          lastPayDay:new Date(result[2].toNumber()*1000).toString()
      })
    })
  }

  getPaid = () => {
    const {payroll,employee} =this.props;
    payroll.getPaid({
        from:'0xa89efed3025c88704ffb994a58303be3f7e23871',//employee,
        gas:1000000
    }).then(() =>{
        alert("success")
    })
  }

  renderContent() {
    const { salary, lastPayDay, balance } = this.state;

    if (!salary || salary === '0') {
      return   <Alert message="你不是员工" type="error" showIcon />;
    }

    return (
      <div>
        <Row gutter={16}>
          <Col span={8}>
            <Card title="薪水">{salary} Ether</Card>
          </Col>
          <Col span={8}>
            <Card title="上次支付">{lastPayDay}</Card>
          </Col>
          <Col span={8}>
            <Card title="帐号金额">{balance} Ether</Card>
          </Col>
        </Row>

        <Button
          type="primary"
          icon="bank"
          onClick={this.getPaid}
        >
          获得酬劳
        </Button>
      </div>
    );
  }

  render() {
    const { account, payroll, web3 } = this.props;

    return (
      <Layout style={{ padding: '0 24px', background: '#fff' }}>
        <Common account={account} payroll={payroll} web3={web3} />
        <h2>个人信息</h2>
        {this.renderContent()}
      </Layout >
    );
  }
}

export default Employee
