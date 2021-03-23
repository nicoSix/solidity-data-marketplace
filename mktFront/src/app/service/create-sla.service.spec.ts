import { TestBed } from '@angular/core/testing';

import { CreateSLAService } from './create-sla.service';

describe('CreateSLAService', () => {
  let service: CreateSLAService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CreateSLAService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
