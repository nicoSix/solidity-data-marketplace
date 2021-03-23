import { TestBed } from '@angular/core/testing';

import { EthcontractService } from './ethcontract.service';

describe('EthcontractService', () => {
  let service: EthcontractService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(EthcontractService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
