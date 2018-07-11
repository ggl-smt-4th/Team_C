import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd';

import EditableCell from './EditableCell';

const FormItem = Form.Item;

const columns = [{
  title: '地址',
  dataIndex: 'address',
  key: 'address',
}, {
  title: '薪水',
  dataIndex: 'salary',
  key: 'salary',
}, {
  title: '上次支付',
  dataIndex: 'lastPayDay',
  key: 'lastPayDay',
}, {
  title: '操作',
  dataIndex: '',
  key: 'action'
}];

class EmployeeList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      employees: [],
      showModal: false
    };

    columns[1].render = (text, record) => (
      <EditableCell
        value={text}
        onChange={ this.updateEmployee.bind(this, record.address) }
      />
    );

    columns[3].render = (text, record) => (
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account, web3 } = this.props;
    payroll.checkInfo.call({
      from: account
    }).then((result) => {
      const employeeCount = result[2].toNumber();

      if (employeeCount === 0) {
        this.setState({loading: false});
        return;
      }

      this.loadEmployees(employeeCount);
    });

  }

  loadEmployees(employeeCount) {
      const {payroll,account,web3} = this.props;
      const requests=[];
      for(let i=0;i<employeeCount;i++){
        requests.push(payroll.checkEmployee.call(i,{from:account}));
      }

      Promise.all(requests)
          .then(values=>{
            const employees=values.map(value=>({
              key:value[0],
              address:value[0],
              salary:value[1].toNumber(),
              lastPayDay:new Date(value[2].toNumber()*1000).toString()
            }));

            this.setState({
                employees:employees,
                loading:false
            })
          })
  }

  addEmployee = () => {
    const {payroll,account}=this.props;
    const {address,salary,employees}=this.state;
    payroll.addEmployee(this.state.address,parseInt(this.state.salary),{
        from:account,
        gas:1000000
      }).then(()=>{
        let employee={
          key:address,
          address:address,
          salary:salary,
          lastPayDay:new Date().toString()
        }
        this.setState({
            address:"",
            salary:"",
            employees:employees.concat(employee),
            loading:false,
            showModal:false
        })
    })
  }

  updateEmployee = (address, salary) => {
      const {payroll,account}=this.props;
      const {employees}=this.state;
      payroll.updateEmployee(address,parseInt(salary),{
          from:account,
          gas:1000000
      }).then(()=>{
          this.setState({
              address:"",
              salary:"",
              employees:employees.map(employee=>{
                if(employee.address==address) {
                  employee.salary=salary;
                  employee.lastPayDay=new Date().toString()
                }
                return employee;
              }),
              loading:false
          })
      })
  }

  removeEmployee = (employeeId) => {
      const {payroll,account}=this.props;
      const {employees}=this.state;
      payroll.removeEmployee(employeeId,{
          from:account,
          gas:1000000
      }).then(()=>{
          this.setState({
              address:"",
              salary:"",
              employees:employees.filter(employee=>employee.address!=employeeId),
              loading:false
          })
      })
  }

  renderModal() {
      return (
      <Modal
          title="增加员工"
          visible={this.state.showModal}
          onOk={this.addEmployee.bind(this)}
          onCancel={() => this.setState({showModal: false})}
      >
        <Form>
          <FormItem label="地址">
            <Input
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
              onChange={salary => this.setState({salary})}
            />
          </FormItem>
        </Form>
      </Modal>
    );

  }

  render() {
    const { loading, employees } = this.state;
    return (
      <div>
        <Button
          type="primary"
          onClick={() => this.setState({showModal: true})}
        >
          增加员工
        </Button>

        {this.renderModal()}

        <Table
          loading={loading}
          dataSource={employees}
          columns={columns}
        />
      </div>
    );
  }
}

export default EmployeeList
