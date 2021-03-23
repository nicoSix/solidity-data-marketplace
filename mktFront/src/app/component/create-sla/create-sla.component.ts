import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import { EthcontractService } from 'src/app/ethcontract.service';
import {ReactiveFormsModule, FormsModule } from '@angular/forms';
import { CreateSLAService } from 'src/app/service/create-sla.service';



@Component({
  selector: 'app-create-sla',
  templateUrl: './create-sla.component.html',
  styleUrls: ['./create-sla.component.css']
})
export class CreateSLAComponent implements OnInit {


  selectForm: FormGroup;
  dataType = [
    {value: 'image'},
    {value: 'csv'},
  ];
  algorithmType = [
    {value: 'ML'},
    {value: 'NN'},
  ];
  infrastructureType = [
    {value: 'Sgx'},
    {value: 'NoSgx'},
  ];

  constructor(private createSlaService: CreateSLAService, private fb: FormBuilder) {

  }


  ngOnInit() {
    this.selectForm = this.fb.group({
      dataType: ['', [Validators.required]],
      algorithmType: ['', [Validators.required]],
      infrastructureType: ['', [Validators.required]],
      maxPrice: ['', [Validators.required]]
    });

  }

  onSubmit() {

    const dt = this.selectForm.get('dataType').value;
    const at = this.selectForm.get('algorithmType').value;
    const it = this.selectForm.get('infrastructureType').value;
    const mp = this.selectForm.get('maxPrice').value;
    

    console.log(dt);
    console.log(at);
    console.log(it);

    this.createSlaService.createAuction(dt, at, it, 100);
  }

}
